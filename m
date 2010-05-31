Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0EaPwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:52:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36170 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0EaPww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=N/dFsR5rEA/MRBfsak7o2VsTlEuX2LvmAhpdBOG53QC0SIPdMpOBU2qERXSVWrvQZL
         oxQHggx7fKxAo03BIgcDijGv6GYftr0Jx90nbh7lPrs5OeyylEnt62w7+jc9YMqLaO3+
         7LrTl+CzeaE88l7kLjaHgcMGS+3of2VM2VcAM=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Hao, Xudong" <xudong.hao@intel.com>
Subject: Re: host panic on kernel 2.6.34
Date: Mon, 31 May 2010 17:52:45 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <BC00F5384FCFC9499AF06F92E8B78A9E04DCCCE242@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <BC00F5384FCFC9499AF06F92E8B78A9E04DCCCE242@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005311752.45884.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 24 maja 2010 o 10:23:11 Hao, Xudong wrote:
> Hi all
> I build latest kvm 37dec075a7854f0f550540bf3b9bbeef37c11e2a, based on
>  kernel 2.6.34, after kvm and kvm_intel module loaded, then /etc/init.d/kvm
>  start, a few minutes later, the system will panic.
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16082
for your bug report, please add your address to the CC list in there, thanks!


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
