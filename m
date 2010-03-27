Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0C0DhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 23:37:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45798
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab0C0DhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 23:37:22 -0400
Date: Fri, 26 Mar 2010 20:37:45 -0700 (PDT)
Message-Id: <20100326.203745.04177541.davem@davemloft.net>
To: rob@landley.net
Cc: blauwirbel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201003262235.48736.rob@landley.net>
References: <201002211025.11588.rob@landley.net>
	<20100221.180658.226784107.davem@davemloft.net>
	<201003262235.48736.rob@landley.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>
Date: Fri, 26 Mar 2010 22:35:47 -0500

> What exactly was the problem with just saying "unsigned short" when you mean 
> an unsigned short?  The way x86 does, and arm?  (If these ever change, it 
> breaks binary compatability.  Not sure what these changes were trying to 
> accomplish...)

I was trying to use well defined types that described the
usage and the origin of the definition.

I'm happy to use "unsigned short" or whatever works better.
Please send a patch.
