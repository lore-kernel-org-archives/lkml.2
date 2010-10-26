Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab0JZRCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:02:18 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:39523 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132Ab0JZRCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:02:15 -0400
Date: Tue, 26 Oct 2010 17:23:22 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia/cm4000: fix error code
Message-ID: <20101026162322.GO25165@prithivi.gnumonks.org>
References: <20101022181024.534fdd15@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20101022181024.534fdd15@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 06:10:24PM +0200, Nicolas Kaiser wrote:
> I'm assuming it's not intended to instantly change the error code
> from -ENODEV to -EIO, is it?
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
