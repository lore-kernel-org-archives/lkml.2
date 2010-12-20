Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab0LTQrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:47:18 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:61693 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab0LTQrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:47:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=S8gd5ouq4C4ZnxHpUG7vcoFzKTHe/ML93sTSFuPQDQ8+A7y+baX8A1dv46YunF7eDn
         N4F+oALmZwj5cx5xGWhJdM4VUjjSI8NFvJAJoWdkXzh1CDlUDBMVyUsogsmnf4Ra7f1q
         mG053sO/G9a2yY38tueMjuLOHglbJitCImARU=
Message-ID: <4D0F8890.2070307@kernel.org>
Date: Mon, 20 Dec 2010 17:47:12 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ozan Caglayan <ozan@pardus.org.tr>, 2010-04-22@ogre.sisk.pl
Subject: Re: [Bug #20232] kworker consumes ~100% CPU on HP Elitebook 8540w
 running 2.6.36_rc6-git4
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>	 <xqq2Z3iR9HJ.A.lMH.Q2fDNB@chimera> <1292841313.2708.137.camel@laptop>
In-Reply-To: <1292841313.2708.137.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/20/2010 11:35 AM, Peter Zijlstra wrote:
> On Sun, 2010-12-19 at 13:50 +0100, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.35 and 2.6.36.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
>> be listed and let the tracking team know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=20232
>> Subject		: kworker consumes ~100% CPU on HP Elitebook 8540w running 2.6.36_rc6-git4
>> Submitter	: Ozan Caglayan <ozan@pardus.org.tr>
>> Date		: 2010-10-13 06:13 (68 days old)
> 
> I'd be thinking that kworker going wonky is something for Tejun to have
> a look at.. Anyway, is it still relevant for current kernels?

It looks like the work is scheduled in loop, so the kworker acting out
seems to be the symptom of the problem not the cause.  Looks like
Rafael already has a proper fix on mind, so...

Thanks.

-- 
tejun
