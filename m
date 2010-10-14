Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0JNReO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:34:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54882 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0JNReM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=pyESbCpEEyeIJoDkXJtjVHnvDEtX+uLd+sv7QhJMaD/ZReH3Vu6wG4vqtHtMQr7oAV
         2fOnbHHBa4JTeDuUwlwMDV+4t2rIUrOxBpL30PgnAJNK1zZIWahyFJFE3tkbNENmAHT7
         FCjvTZauylPdSWFllCTA54spAnjw5pxQ8l86A=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.36-rc7: inconsistent lock state: inconsistent {IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
Date: Thu, 14 Oct 2010 19:34:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, selinux@gmail.com
References: <20101011201007.GA29707@redhat.com>
In-Reply-To: <20101011201007.GA29707@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010141934.05379.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 11 października 2010 o 22:10:07 Dave Jones wrote:
> We got this report from a Fedora user (cc'd) today..
> 
> 	Dave
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=20322
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
