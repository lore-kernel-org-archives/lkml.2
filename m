Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284Ab2B1TZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:25:45 -0500
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:44182 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966050Ab2B1TZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:25:44 -0500
Subject: Re: [RFC][PATCH 6/6] USB: ffs-test: Don't duplicate
 {get,put}_unaligned*() functions
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <4F4D13DB.1040205@zytor.com>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
	 <1330436245-24875-7-git-send-email-matt@console-pimps.org>
	 <4F4D13DB.1040205@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Tue, 28 Feb 2012 20:25:40 +0100
Message-ID: <1330457140.2706.7.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 09:50 -0800, H. Peter Anvin wrote:
> On 02/28/2012 05:37 AM, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > Use the header file in tools/include instead of duplicating the endian
> > functions.
> > 
> > Cc: Davidlohr Bueso <dave@gnu.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> 
Acked-by: Davidlohr Bueso <dave@gnu.org>

> Greg and Dave, since the rest of this series is all in the x86
> directory, mind if I pick it up and put it in the -tip tree including
> this patch?

Fine by me.

