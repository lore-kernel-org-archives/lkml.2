Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0HXOve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:51:34 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:27965 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049Ab0HXOvb (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Tue, 24 Aug 2010 10:51:31 -0400
Message-Id: <4C74690E020000230001F3F1@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 24 Aug 2010 08:51:26 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <gregkh@suse.de>, <trenn@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

於 二，2010-08-24 於 15:22 +0100，Matthew Garrett 提到：
> Erm. Sorry about that - I just realised that there's actually a fairly 
> significant problem with it :) Right now you'll perform the register 
> call unconditionally on module load. You need to make sure that there's 
> actually Poulsbo hardware in the system, either by registering as a 
> proper PCI driver and calling acpi_video_register in your probe function 
> (and unregister in your remove function) or walking the PCI device list 
> looking for a psb device.
> 

Sorry! You are right! That's my fail!
I will put the PCI device check in probe function then send patch again.

Appreciate for your review.


Thank's a lot!
Joey Lee

