Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1FAWpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:45:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:44341 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1FAWpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:45:46 -0400
X-ExtLoop1: 1
Date: Wed, 1 Jun 2011 23:32:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, vinod.koul@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: intel_sst: replacing spaces by tabs
Message-ID: <20110601233257.00f1e0fc@bob.linux.org.uk>
In-Reply-To: <1306966399-31567-1-git-send-email-chihau@gmail.com>
References: <1306966399-31567-1-git-send-email-chihau@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Jun 2011 18:13:19 -0400
Chihau Chau <chihau@gmail.com> wrote:

> This is a code style issue patch that replaces spaces by tabs.

The goal with intel_sst is to replace it with the ALSA ASoC driver so I
don't think space fixing it is actually useful, just code fixes so we
can keep it on life support until we shoot it.
