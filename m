Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab2JHQpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:45:38 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56748 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab2JHQpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:45:35 -0400
Message-ID: <1349714729.15966.167.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: boot failure on i7-3317u in Samsung 900x3c
From: Matt Fleming <matt@console-pimps.org>
To: Mike Bakhterev <mike.bakhterev@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 08 Oct 2012 17:45:29 +0100
In-Reply-To: <CACx33ghsnYz0VNwEbhuyn7ZgrtamHfrTKHR4E0b9Q+LpahcDXw@mail.gmail.com>
References: <CACx33gg6Hmh8E0Mv5TLdi5ufZcppHMws8XAdfaThF_Y2QBb5vA@mail.gmail.com>
	 <1349690974.15966.113.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CACx33ghsnYz0VNwEbhuyn7ZgrtamHfrTKHR4E0b9Q+LpahcDXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 21:17 +0600, Mike Bakhterev wrote:
> > Does anyone have a clue how to diagnose this further? I still think it's
> > a buggy UEFI implementation, especially since it ships with a CSM. Is it
> > possible that these MCE errors are non-fatal on Win 7/8?
> >
> 
> Are there any info on how to decode this MCE code? It is not covered
> in Intel's manuals. Hard to reason without any knowledge.

mcelog should be able to parse your MCE codes.

-- 
Matt Fleming, Intel Open Source Technology Center

