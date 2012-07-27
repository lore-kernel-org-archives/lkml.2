Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2G0HeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 03:34:20 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49394 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2G0HeT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 27 Jul 2012 03:34:19 -0400
Message-Id: <501260980200007800090E08@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 27 Jul 2012 08:34:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Jackson" <Ian.Jackson@eu.citrix.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC PATCH] Boot PV guests with more than
 128GB (v1) for 3.7
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.07.12 at 22:47, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>  2). Allocate a new array, copy the existing P2M into it,
>     revector the P2M tree to use that, and return the old
>     P2M to the memory allocate. This has the advantage that
>     it sets the stage for using XEN_ELF_NOTE_INIT_P2M
>     feature. That feature allows us to set the exact virtual
>     address space we want for the P2M - and allows us to
>     boot as initial domain on large machines.

And I would hope that the tools would get updated to recognize
this note too, so that huge DomU-s would become possible as
well.

Jan

