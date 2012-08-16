Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2HPSyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:54:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54377 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2HPSyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <ba3d3f54baf08e7252312fa51e590e5d0ca50206.1345055639.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<ba3d3f54baf08e7252312fa51e590e5d0ca50206.1345055639.git.dmitry.kasatkin@intel.com>
Date: Thu, 16 Aug 2012 14:54:49 -0400
Message-ID: <CA+5PVA6Ah-mCiSSRC+TJ0vYq-OHxn4_+-iNpErjGiYO3tbeOtQ@mail.gmail.com>
Subject: Re: [RFC v2 6/7] modsig: initialize the _module public key keyring
From: Josh Boyer <jwboyer@gmail.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
>
> Create and initialize the _module public key keyring with the builtin
> public key.
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

This seems like it could be folded into "modsig: add
integrity_module_check hook" or "modsig: verify module integrity based
on signature".  Not sure why it needs to be a separate patch at first
glance.

josh
