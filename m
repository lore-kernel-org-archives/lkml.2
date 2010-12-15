Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab0LOC1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:27:39 -0500
Received: from relay1.sgi.com ([192.48.179.29]:36337 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753Ab0LOC1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:27:37 -0500
Date: Tue, 14 Dec 2010 20:27:35 -0600
From: Jack Steiner <steiner@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: lenb@kernel.org, hmh@hmh.eng.br, tony.luck@gmail.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gbeshers@sgi.com
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
Message-ID: <20101215022735.GA19601@sgi.com>
References: <20101214220932.GA1206@sgi.com> <4D07F6A2.2030706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D07F6A2.2030706@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 02:58:42PM -0800, H. Peter Anvin wrote:
> On 12/14/2010 02:09 PM, Jack Steiner wrote:
> > Map ACPI tables as WB on x86_64. No substantive changes to IA64.
> 
> Why just x86-64?

We never observed a performance problem on IA64. Not sure if it maps
ACPI space as WB or not. Since I did not have easy access to
an ia64, I chose not to make any changes to the way it maps
the table.

