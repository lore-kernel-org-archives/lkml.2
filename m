Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab1BYVtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:49:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34408 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1BYVtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=SMwOStGM5RzNhMh5DHsK8dkDVfNkqQYVXGtOoPru/CT0T07G9ywSeX+S7k+t1k2PUx
         oCR80vYDpaQB+V1/WthUzXgQTRQfVYbiFEKlaS4pwIRPScz1l1fZ3iZGH8ad4dbb5neC
         9sjPvrsP97rZ6gj6p+hyqzzkDSyg5v1v13M1A=
Message-ID: <4D6823DD.6040809@gmail.com>
Date: Sat, 26 Feb 2011 00:49:17 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Matthew Garrett <mjg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
References: <20110209224006.GA11202@kroah.com> <AANLkTikrr6Gu_qoq73ASC95E0HQC1p6KzDPLxo=J_rva@mail.gmail.com> <20110225210334.GB16860@kroah.com>
In-Reply-To: <20110225210334.GB16860@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------080609060204050004020501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080609060204050004020501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/26/2011 12:03 AM, Greg KH wrote:
> This should work, as we support the N150/N210/N220 versions.
>
> Can you provide the output of:
> 	grep ./sys/class/dmi/id/*
>
> so I can verify this?
Sure. Please find it attached. It is taken on a stock Debian kernel, without
your patch.

Could I have configured the kernel incorrectly?

Thanks :)

Sincerely,
Nick

--------------080609060204050004020501
Content-Type: text/plain;
 name="dmi_id_grep.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmi_id_grep.txt"

/sys/class/dmi/id/bios_date:01/29/2010
/sys/class/dmi/id/bios_vendor:Phoenix Technologies Ltd.
/sys/class/dmi/id/bios_version:06JI.M053.20100129.JIP
/sys/class/dmi/id/board_asset_tag:SAMSUNG
/sys/class/dmi/id/board_name:N150/N210/N220             
/sys/class/dmi/id/board_serial:123490EN400015
/sys/class/dmi/id/board_vendor:SAMSUNG ELECTRONICS CO., LTD.
/sys/class/dmi/id/board_version:Not Applicable
/sys/class/dmi/id/chassis_asset_tag:No Asset Tag
/sys/class/dmi/id/chassis_serial:None        
/sys/class/dmi/id/chassis_type:10
/sys/class/dmi/id/chassis_vendor:SAMSUNG ELECTRONICS CO., LTD.
/sys/class/dmi/id/chassis_version:N/A         
/sys/class/dmi/id/modalias:dmi:bvnPhoenixTechnologiesLtd.:bvr06JI.M053.20100129.JIP:bd01/29/2010:svnSAMSUNGELECTRONICSCO.,LTD.:pnN150/N210/N220:pvrNotApplicable:rvnSAMSUNGELECTRONICSCO.,LTD.:rnN150/N210/N220:rvrNotApplicable:cvnSAMSUNGELECTRONICSCO.,LTD.:ct10:cvrN/A:
/sys/class/dmi/id/product_name:N150/N210/N220             
/sys/class/dmi/id/product_serial:ZO1193HZ200860
/sys/class/dmi/id/product_uuid:40B5E830-E81D-B211-8000-E54EB00EA058
/sys/class/dmi/id/product_version:Not Applicable
/sys/class/dmi/id/sys_vendor:SAMSUNG ELECTRONICS CO., LTD.
/sys/class/dmi/id/uevent:MODALIAS=dmi:bvnPhoenixTechnologiesLtd.:bvr06JI.M053.20100129.JIP:bd01/29/2010:svnSAMSUNGELECTRONICSCO.,LTD.:pnN150/N210/N220:pvrNotApplicable:rvnSAMSUNGELECTRONICSCO.,LTD.:rnN150/N210/N220:rvrNotApplicable:cvnSAMSUNGELECTRONICSCO.,LTD.:ct10:cvrN/A:

--------------080609060204050004020501--
