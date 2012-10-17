Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2JQK6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:58:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53686 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2JQK6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:58:37 -0400
Message-ID: <1350471512.1242.64.camel@hornet>
Subject: Re: [PATCH] regulator: vexpress: Add terminating entry for
 vexpress_regulator_of_match table
From: Pawel Moll <pawel.moll@arm.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Oct 2012 11:58:32 +0100
In-Reply-To: <1350435620.5718.1.camel@phoenix>
References: <1350435620.5718.1.camel@phoenix>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 17 Oct 2012 10:58:32.0832 (UTC) FILETIME=[5942B000:01CDAC56]
X-MC-Unique: 112101711583505201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 02:00 +0100, Axel Lin wrote:
> The of_device_id table is supposed to be zero-terminated.

Damn, stupid mistake. Thanks for spotting this!

Pawel


