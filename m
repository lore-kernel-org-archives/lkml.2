Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0EKP6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:58:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49645 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752365Ab0EKP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:58:31 -0400
Date: Tue, 11 May 2010 11:58:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Alek" <alek.du@intel.com>
cc: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
In-Reply-To: <20100511113120.02787f96@dxy2>
Message-ID: <Pine.LNX.4.44L0.1005111156150.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alek:

By the way, does the Moorestown platform support multiple ports 
on the root hub?  If it does then using a single time delay (instead of 
a separate delay for each port) makes sense.  But if it doesn't then 
there's no reason to move the power-up and power-down delays outside 
the port loops.

Alan Stern

