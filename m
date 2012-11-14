Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423028Ab2KNOis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 09:38:48 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64659 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422981Ab2KNOiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 09:38:46 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/5] Add /proc device tree updating to of node add/remove
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        devicetree-discuss@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <506BA905.4090000@linux.vnet.ibm.com>
References: <506B2E63.5090900@linux.vnet.ibm.com> <506BA905.4090000@linux.vnet.ibm.com>
Date: Wed, 14 Nov 2012 14:38:27 +0000
Message-Id: <20121114143827.19DB73E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2012 21:55:01 -0500, Nathan Fontenot <nfont@linux.vnet.ibm.com> wrote:
> When adding or removing a device tree node we should also update
> the device tree in /proc/device-tree. This action is already done in the
> generic OF code for adding/removing properties of a node. This patch adds
> this functionality for nodes.
> 
> Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com> 

For the whole series:

Acked-by: Grant Likely <grant.likely@secretlab.ca>


