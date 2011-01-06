Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1AFAsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:48:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:10892 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab1AFAsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:48:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="370663017"
Date: Thu, 6 Jan 2011 00:24:29 +0000
From: Alan Cox <alan@linux.intel.com>
To: Russ Gorby <russ.gorby@intel.com>
Cc: gregkh@suse.de, segoon@openwall.com, <richardx.r.gorby@intel.com>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 1/7] serial: ifx6x60: fixed call to tty_port_init
Message-ID: <20110106002429.162d1f87@bob.linux.org.uk>
In-Reply-To: <1294272313-15899-2-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/7] IFX6X60 patchset: 01/05/2011>
	<1294272313-15899-2-git-send-email-russ.gorby@intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Jan 2011 16:05:07 -0800
Russ Gorby <russ.gorby@intel.com> wrote:

> The port ops must be set AFTER calling port init as that function
> zeroes the structure
> 
> Signed-off-by: Russ Gorby <russ.gorby@intel.com>

Acked-by: Alan Cox <alan@linux.intel.com>

(Your mail headers appear corrupt btw ?)
