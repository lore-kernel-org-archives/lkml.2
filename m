Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2BCRiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:38:23 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:41087 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab2BCRiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:38:21 -0500
Date: Fri, 3 Feb 2012 15:35:51 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Berger <stefan@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/2] tpm_tis: Clean up after module_param cleanup
Message-ID: <20120203173550.GB21715@hardened-box.ibm.com>
References: <20120120175848.310554335@linux.vnet.ibm.com>
 <20120120175931.685896848@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120175931.685896848@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12020317-8936-0000-0000-000005CFD0EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jan 2012, Stefan Berger wrote:

> Commit 90ab5ee94171b3e28de6bb42ee30b527014e0be7 changed the
> itpm module parameter from int to bool. Some other changes
> need to be done to clean up after this change.
> 
> Signed-off-by: Stefan Berger <stefan@linux.vnet.ibm.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
>

Applied to github.com:srajiv/tpm.git next

Thanks,
Rajiv

