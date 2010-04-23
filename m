Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0DWNeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:34:11 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:52252 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab0DWNeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dssna7HVf2rfZICgWDjQZBrkwlm59r5cS/35BuiIXhAM2yCzwKpjX/qfrtkMh04qHT
         6VRW7bpb39xzIAf2O1Q3vq0E743VV9JzSYJGaJMuq5xNqfInMdq8oUdb1gLUV2tIvNnJ
         YVuHjqUjRP2HyPbBe5uP3SrK5fXorU+TD/sDc=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Another BUG_ON() in blkio controller
Date: Fri, 23 Apr 2010 15:33:50 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4; KDE/4.3.4; i686; ; )
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20100421201201.GF3275@redhat.com>
In-Reply-To: <20100421201201.GF3275@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004231533.51014.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On środa, 21 kwietnia 2010 o 22:12:01 Vivek Goyal wrote:
> Hi Nauman,
> 
> There is another BUG_ON() hitting in my testing.

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15842
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
