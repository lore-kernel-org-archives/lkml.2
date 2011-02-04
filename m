Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab1BDM4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:56:50 -0500
Received: from gate.eia.be ([194.78.71.18]:50367 "EHLO mail.eia.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1BDM4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:56:48 -0500
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Feb 2011 07:56:47 EST
Date: Fri, 4 Feb 2011 13:42:33 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org
Subject: Re: [PATCH 12/20] net: can: at91_can: world-writable sysfs files
Message-ID: <20110204124233.GB334@e-circ.dyndns.org>
References: <cover.1296818921.git.segoon@openwall.com>
 <a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Feb 2011 12:42:37.0211 (UTC) FILETIME=[00AC8EB0:01CBC469]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 03:23:50PM +0300, Vasiliy Kulikov wrote:
> Don't allow everybody to write to mb0_id file.
> 
very well!

Acked-by: Kurt Van Dijck <kurt.van.dijck@eia.be>
