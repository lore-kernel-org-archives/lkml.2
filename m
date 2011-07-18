Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1GRJux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:50:53 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38867 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1GRJuw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 18 Jul 2011 05:50:52 -0400
Message-Id: <4E241E15020000780004DDE4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 18 Jul 2011 10:50:45 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ian Campbell" <Ian.Campbell@eu.citrix.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "Keir Fraser" <keir.xen@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "KonradRzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on
	 resume
References: <CA499EDA.1E10E%keir.xen@gmail.com>
 <1310977905.20648.26.camel@zakaz.uk.xensource.com>
 <4E240F3D020000780004DD70@nat28.tlf.novell.com>
 <1310979918.20648.31.camel@zakaz.uk.xensource.com>
In-Reply-To: <1310979918.20648.31.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.07.11 at 11:05, Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> Note that XENFEAT_writable_descriptor_tables means that the guest kernel
> should not make pagetable pages RO at all, which is different from the
> hypervisor's support for writing to RO pagetables (i.e. emulating
> pagetable updates).

Yeah, sorry, I keep mixing up the inverse meanings of
XENFEAT_writable_page_tables and VMASST_TYPE_writable_pagetables...

Jan

