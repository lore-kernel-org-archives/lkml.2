Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1HSOCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:02:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab1HSOCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:02:38 -0400
Message-ID: <4E4E6CFC.9090400@suse.cz>
Date: Fri, 19 Aug 2011 16:02:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] Kconfig library check merge
References: <1307387767-9237-1-git-send-email-lacombar@gmail.com> <1309571259-15241-1-git-send-email-lacombar@gmail.com> <CACqU3MVxiwmRQ9MQFAB9ymnTt3pEG+ZTAS5seQ7bgpetuafcMQ@mail.gmail.com> <4E25813D.9020600@suse.cz> <CACqU3MWL5fueoZzH8yJ7V3jgDhpLy+CgU7qDyDRXXdOAGUO8tQ@mail.gmail.com>
In-Reply-To: <CACqU3MWL5fueoZzH8yJ7V3jgDhpLy+CgU7qDyDRXXdOAGUO8tQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.8.2011 07:29, Arnaud Lacombe wrote:
> Hi Michal,
> 
> On Tue, Jul 19, 2011 at 9:06 AM, Michal Marek <mmarek@suse.cz> wrote:
>> On 18.7.2011 21:03, Arnaud Lacombe wrote:
>>>
>>> Hi,
>>>
>>> On Fri, Jul 1, 2011 at 9:47 PM, Arnaud Lacombe<lacombar@gmail.com>  wrote:
>>>>
>>>> Hi Michal,
>>>>
>>>> You'll find hereafter a splitted-down version of my previous preliminary
>>>> patch. I will eventually need to complete the second commit message, it
>>>> is
>>>> missing the purpose of the change, which AFAIR was a failure of
>>>> something.
>>>>
>>>> Comments welcome!
>>>>
>>>>  - Arnaud
>>>>
>>>> Arnaud Lacombe (7):
>>>>  kconfig/Makefile: add pretty printer for moc(1)
>>>>  kconfig/Makefile: ensure `conf' appears last in `hostprogs-y'
>>>>  kconfig/check.sh: prepare for generic check
>>>>  kconfig: move QT checks to `scripts/kconfig/check.sh'
>>>>  kconfig: move GTK checks to `scripts/kconfig/check.sh'
>>>>  kconfig: move ncurses checks to `scripts/kconfig/check.sh'
>>>>  kconfig: add stub for nconf checks
>>>>
>>>>  scripts/kconfig/Makefile                   |  155 +++++-----------------
>>>>  scripts/kconfig/check.sh                   |  199
>>>> ++++++++++++++++++++++++++--
>>>>  scripts/kconfig/lxdialog/check-lxdialog.sh |   84 ------------
>>>>  3 files changed, 223 insertions(+), 215 deletions(-)
>>>>
>>> ping ?
>>
>> Pong. The series looks fine to me. I have no strong opinion about the name
>> of the check script, pick whatever you like and send a series with your
>> signoff.
>>
> The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:
> 
>   Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)
> 
> are available in the git repository at:
>   git@github.com:lacombar/linux-2.6.git master/kconfig-generic-checks
[...]
>       kconfig: move ncurses checks to `scripts/kconfig/check.sh'

Hi,
this broke make nconfig for me, because it does no longer passes
-I/usr/include/ncurses to the compiler and so menu.h is not found. Also,
scripts/kconfig/lxdialog/check-lxdialog.sh was left empty by this commit.

Michal
