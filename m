Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0IIVXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:23:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60800 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0IIVXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:23:53 -0400
Message-ID: <4C895028.3010609@zytor.com>
Date: Thu, 09 Sep 2010 14:22:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: Re: [PATCH 07/12] x86-64: Simplify constraints for fxsave/fxtstor
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com> <1283563039-3466-8-git-send-email-brgerst@gmail.com>
In-Reply-To: <1283563039-3466-8-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 06:17 PM, Brian Gerst wrote:
> Use the "R" constraint (legacy register) instead of listing all the
> possible registers.  Clean up the comments as well.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Hi Brian,

Have you tested this on *old* versions of gcc?  Since the whole point of
that butt-ugly code sequence is to support now-historic versions of
binutils, we need to make sure that "R" was supposed on the
corresponding gcc versions...

	-hpa
