Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2IVN2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 09:28:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2IVN2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 09:28:09 -0400
MIME-Version: 1.0
In-Reply-To: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
Date: Sat, 22 Sep 2012 09:28:09 -0400
X-Google-Sender-Auth: FOPo6sFOLkjnm_mG4tFtAHE4wvc
Message-ID: <CACJDEmreY+MS8Rz_Y+wk0BdAA0PsOeQ3SAEbysLT+J-PqnKSbw@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] Xen-SWIOTLB fixes (v4) for v3.7
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> to allow it to use an io_tlb passed in. Note: I hadn't tested this
> on IA64 and that is something I need to do.

Done. I got my hands on a HP zx6000 and the patch series did not show
any regressions.
