Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2G0Kdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:33:35 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54529 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2G0Kde convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 27 Jul 2012 06:33:34 -0400
Message-Id: <50128A9B0200007800090EFB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 27 Jul 2012 11:33:31 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ian Campbell" <Ian.Campbell@citrix.com>
Cc: "Ian Jackson" <Ian.Jackson@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC PATCH] Boot PV guests with more than
 128GB (v1) for 3.7
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
 <501260980200007800090E08@nat28.tlf.novell.com>
 <1343383205.6812.137.camel@zakaz.uk.xensource.com>
 <501286E50200007800090ECB@nat28.tlf.novell.com>
 <1343384489.6812.143.camel@zakaz.uk.xensource.com>
In-Reply-To: <1343384489.6812.143.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.07.12 at 12:21, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> I was actually think of the issue with 32 bit PV guests accessing MFN
> space > 160G, even if they are themselves small, which is a separate
> concern.

That can be made work if really needed, but not via the
mechanism we're talking about here. The question is whether
it's worth it.

Jan

