Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823Ab0GAWPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:15:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53784 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759787Ab0GAWPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y7UwYci/JIlbXo29mFLJOoFGqExb5guzjKElFTKnX+mu7zqfiEi9hc5eh4LuJDiu6Y
         lJmuXUEbmA3+G9Br6zbpeRKVHt6ozsIeTnvkSKenxDj/T1PtwU16Q9AdYVYQhVRVZDd6
         cp0Jy2y/YgAZaNXYhpaaaULqRQ/jupRbh9MqM=
MIME-Version: 1.0
In-Reply-To: <1278013320.7738.19.camel@c-dwalke-linux.qualcomm.com>
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org>
	<1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org>
	<20100701101746.3810cc3b.randy.dunlap@oracle.com>
	<20100701180241.GA3594@basil.fritz.box>
	<1278012503.7738.17.camel@c-dwalke-linux.qualcomm.com>
	<20100701193850.GB3594@basil.fritz.box>
	<1278013320.7738.19.camel@c-dwalke-linux.qualcomm.com>
Date: Thu, 1 Jul 2010 17:15:27 -0500
Message-ID: <AANLkTinABCSdN6hnXVOvVZ12f1QBMR_UAi62qW8GmlkL@mail.gmail.com>
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
From: Hari Kanigeri <hari.kanigeri@gmail.com>
To: Daniel Walker <dwalker@codeaurora.org>,
       Zach Pfeffer <zpfeffer@codeaurora.org>
Cc: Andi Kleen <andi@firstfloor.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       mel@csn.ul.ie, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> He demonstrated the usage of his code in one of the emails he sent out
> initially. Did you go over that, and what (or how many) step would you
> use with the current code to do the same thing?

-- So is this patch set adding layers and abstractions to help the User ?

If the idea is to share some memory across multiple devices, I guess
you can achieve the same by calling the map function provided by iommu
module and sharing the mapped address to the 10's or 100's of devices
to access the buffers. You would only need a dedicated virtual pool
per IOMMU device to manage its virtual memory allocations.

Hari
