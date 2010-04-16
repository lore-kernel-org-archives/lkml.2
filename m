Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab0DPKfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 06:35:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35620 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab0DPKfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 06:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=FKMa7WHHFVXWZNjb5UWt6DB0q6kBWb6Z/BYSIwOot88fDgK9Uvmt4wjxh789Xt15jc
         YM42TeGqMMeukUxP/71fLIrXavi4TCXnE8fN4jbP27Ud+wsJ9jMO0Rs20oEjdR7v1lGd
         J9HSLdYXpnHNlrc69+r4DfPbTrb4/cmk5AgVA=
Message-ID: <4BC83D56.5050203@roadrunner.com>
Date: Fri, 16 Apr 2010 06:35:02 -0400
From: Frank Griffin <ftg@roadrunner.com>
Reply-To: ftg@roadrunner.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090903 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>,
       Jaroslav Kysela <perex@perex.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
References: <4BC4E812.6050602@tremplin-utc.net>	<s5h633u5zx1.wl%tiwai@suse.de>	<4BC5A566.8060106@tremplin-utc.net>	<s5hy6gqvx9n.wl%tiwai@suse.de>	<4BC782E5.7070900@tremplin-utc.net> <s5hzl13u93u.wl%tiwai@suse.de>
In-Reply-To: <s5hzl13u93u.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> There is a quirk table in sound/pci/hda_intel.c to check PCI SSID.
> I already added an entry for Frank's machine on sound git tree which
> will be included in the pull request I'm going to send soon.
> (Sorry the mail went outside since Frank's reply was private.)
>   
Not a problem, I just didn't want to spam the others with the rather 
large command output :)
