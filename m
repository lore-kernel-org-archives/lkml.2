Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0C3IP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:15:58 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33633 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab0C3IP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:15:56 -0400
X-Auth-Info: ZHFDgK8LPD10a6Qo2xniX421vaqLQB+OpXRuAIJmwzM=
Message-ID: <4BB1B2DA.60002@grandegger.com>
Date: Tue, 30 Mar 2010 10:14:18 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
       netdev@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN	module
References: <> <1269881932-3803-3-git-send-email-iws@ovro.caltech.edu>
In-Reply-To: <1269881932-3803-3-git-send-email-iws@ovro.caltech.edu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira W. Snyder wrote:
> The Janz VMOD-ICAN3 is a MODULbus daughterboard which fits onto any
> MODULbus carrier board. It is an intelligent CAN controller with a
> microcontroller and associated firmware.
> 
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>

Acked-by: Wolfgang Grandegger <wg@grandegger.com>
