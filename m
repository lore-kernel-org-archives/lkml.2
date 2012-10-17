Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2JQLCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:02:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:44590 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab2JQLCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:02:06 -0400
Message-ID: <1350471723.1242.67.camel@hornet>
Subject: Re: [PATCH RFT] regulator: vexpress: Add missing n_voltages setting
From: Pawel Moll <pawel.moll@arm.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Oct 2012 12:02:03 +0100
In-Reply-To: <1350444418.4562.1.camel@phoenix>
References: <1350444418.4562.1.camel@phoenix>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 17 Oct 2012 11:02:03.0397 (UTC) FILETIME=[D6C45B50:01CDAC56]
X-MC-Unique: 112101712020404801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 04:26 +0100, Axel Lin wrote:
> I don't have a chance to compile test this patch because I could not
> find VEXPRESS_CONFIG in current tree.
> Can you help testing this patch?

I'll be more than happy to help, but can you please tell me what use
case you have in mind? The "reg->desc.continuous_voltage_range = true;"
together with this patch:

http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commitdiff;h=bd7a2b600ace90c8819495b639a744c8f5c68feb

were supposed to make the n_voltages unnecessary, as this regulator is
(in theory at least) capable of setting any voltage in the constraints
range, so there are not real operating points.

Cheers!

Paweł


