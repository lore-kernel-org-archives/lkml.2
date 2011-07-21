Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab1GUA7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 20:59:12 -0400
Received: from ozlabs.org ([203.10.76.45]:58475 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1GUA7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 20:59:11 -0400
Date: Thu, 21 Jul 2011 10:59:09 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Ayman Elkhashab <aymane@elkhashab.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Ayman El-Khashab <ayman@elkhashab.com>
Subject: Re: [v3 PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the
 460sx
Message-ID: <20110721005909.GN20597@ozlabs.org>
Mail-Followup-To: Ayman Elkhashab <aymane@elkhashab.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Ayman El-Khashab <ayman@elkhashab.com>
References: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
 <1311166949-2543-1-git-send-email-aymane@elkhashab.com>
 <1311166949-2543-2-git-send-email-aymane@elkhashab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1311166949-2543-2-git-send-email-aymane@elkhashab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 08:02:29AM -0500, Ayman Elkhashab wrote:
> From: Ayman El-Khashab <ayman@elkhashab.com>
> 
> Adds a register to the config space for the 460sx.  Changes the vc0
> detect to a pll detect.  maps configuration space to test the link
> status.  changes the setup to enable gen2 devices to operate at gen2
> speeds.  fixes mapping that was not correct for the 460sx.  added
> bit definitions for the OMRxMSKL registers.  Removed reserved bit
> that was set incorrectly in the OMR2MSKL register.

FWIW Looks good to me.

Yours Tony
