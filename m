Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0JPTUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 15:20:32 -0400
Received: from canuck.infradead.org ([134.117.69.58]:50368 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab0JPTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 15:20:31 -0400
Date: Sat, 16 Oct 2010 15:20:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, hpa@zytor.com, devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101016192027.GA6883@infradead.org>
References: <20101016065206.GO4681@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016065206.GO4681@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides the algorithmic problems with ima, why is kernel.org using
IMA to start with?  Except for IBM looking for a reason to jusity why
TPM isn't a completely waster of ressources it's pointless.  And it was
only merged under the premise that it would not affect innocent normal
users.

