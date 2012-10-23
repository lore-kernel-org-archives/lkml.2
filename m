Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab2JWPjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:39:52 -0400
Received: from mail.x86-64.org ([217.9.48.20]:53509 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab2JWPjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:39:51 -0400
Date: Tue, 23 Oct 2012 17:39:45 +0200
From: Borislav Petkov <bp@amd64.org>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac: fix buffer overrun if no suitable bandwidth found
Message-ID: <20121023153945.GA16140@aftab.osrc.amd.com>
References: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350919858-26202-1-git-send-email-kirjanov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 07:30:58PM +0400, Denis Kirjanov wrote:
> fix buffer overrun if no suitable bandwidth found
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>

Applied with modifications and stable dropped.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
