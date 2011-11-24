Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1KXKZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:25:33 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:53555 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab1KXKZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:25:32 -0500
Date: Thu, 24 Nov 2011 11:24:53 +0100
From: Ivan Djelic <ivan.djelic@parrot.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 13/16] mtd/docg3: add ECC correction code
Message-ID: <20111124102453.GF28830@parrot.com>
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
 <1321714978-24543-14-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321714978-24543-14-git-send-email-robert.jarzmik@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 03:02:55PM +0000, Robert Jarzmik wrote:
> Credit for discovering the BCH algorith parameters, and bit
> reversing algorithm is to be give to Mike Dunn and Ivan
> Djelic.
> 
> The BCH correction code relied upon the BCH library, where
> all data and ECC is bit-reversed. The BCH library works
> correctly when each input byte is bit-reversed, and
> accordingly ECC output is also bit-reversed.
> 

Reviewed-by: Ivan Djelic <ivan.djelic@parrot.com>
