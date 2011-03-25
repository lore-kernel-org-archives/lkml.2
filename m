Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1CYA5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 20:57:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39742 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab1CYA5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 20:57:22 -0400
X-Sasl-enc: GH+NsKGTm1gREt5pNnQIHTQYCKeYd2pZQoNawkuuWKoi 1301014640
Date: Thu, 24 Mar 2011 21:57:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Burt Triplett <burt@pbjtriplett.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BITS handling of CPU microcode updates
Message-ID: <20110325005716.GA4535@khazad-dum.debian.net>
References: <4D65EE74.1050709@pbjtriplett.org>
 <20110312023001.GB27550@khazad-dum.debian.net>
 <4D87E2CD.6020306@pbjtriplett.org>
 <20110324001451.GA7950@khazad-dum.debian.net>
 <4D8BAF4F.30609@pbjtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8BAF4F.30609@pbjtriplett.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Burt Triplett wrote:
> Out of curiosity, which other discrepancies did you encounter?

That was a false alarm.  We use sync_core() instead of directly calling
CPUID(1), which right now is about the same, just more obfuscated and
complicated depending on some config options.  Well, as long as
sync_core() doesn't change in the future.

There are also SPARSE warnings in the driver, but the code itself is
correct.

> Also, please CC me on the patch, and I'll review the changes.

I will post it in a few minutes.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
