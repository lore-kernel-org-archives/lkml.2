Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0DTVMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:12:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab0DTVMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:12:05 -0400
Message-ID: <4BCE188A.1060408@redhat.com>
Date: Tue, 20 Apr 2010 17:11:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [Bug #15672] KVM bug, git bisected
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.7L.6RSzLB@tosh>
In-Reply-To: <YeFfFNFyTSF.A.7L.6RSzLB@tosh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 11:19 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15672
> Subject		: KVM bug, git bisected
> Submitter	: Kent Overstreet<kent.overstreet@gmail.com>
> Date		: 2010-03-27 12:43 (24 days old)
> First-Bad-Commit: http://kernel.org/git/linus/5beb49305251e5669852ed541e8e2f2f7696c53e
> Message-ID	:<4BADFD74.8060904@gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=126969385121711&w=2

Should be fixed by commit ea90002b0fa7bdee86ec22eba1d951f30bf043a6

