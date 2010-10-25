Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024Ab0JYKfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:35:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52353 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab0JYKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:35:30 -0400
Subject: Re: [RFC PATCH 09/18] ARM: LPAE: Add fault handling support
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101025101711.GA32026@shutemov.name>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
	 <20101025090024.25275.59418.stgit@e102109-lin.cambridge.arm.com>
	 <20101025101711.GA32026@shutemov.name>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 25 Oct 2010 11:35:22 +0100
Message-ID: <1288002922.14756.10.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 10:35:23.0003 (UTC) FILETIME=[54325CB0:01CB7430]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 11:17 +0100, Kirill A. Shutemov wrote:
> On Mon, Oct 25, 2010 at 10:00:24AM +0100, Catalin Marinas wrote:
> > +     { do_bad,               SIGILL,  BUS_ADRALN,    "alignment fault"               },
> 
> s/SIGILL/SIGBUS/

Good point, thanks.

Catalin


