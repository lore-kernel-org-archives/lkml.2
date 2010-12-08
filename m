Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0LHRzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:55:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49893
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318Ab0LHRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:55:35 -0500
Date: Wed, 08 Dec 2010 09:56:03 -0800 (PST)
Message-Id: <20101208.095603.232759946.davem@davemloft.net>
To: tfransosi@gmail.com
Cc: linux-kernel@vger.kernel.org, ericvh@gmail.com, sripathik@in.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jvrao@linux.vnet.ibm.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/9p/protocol.c: Remove duplicated macros.
From: David Miller <davem@davemloft.net>
In-Reply-To: <3300e3823b702d35658175ff6379a4f77fa9a5b0.1291512089.git.tfransosi@gmail.com>
References: <3300e3823b702d35658175ff6379a4f77fa9a5b0.1291512089.git.tfransosi@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thiago Farina <tfransosi@gmail.com>
Date: Sat,  4 Dec 2010 23:22:46 -0200

> Use the macros already provided by kernel.h file.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>

I'll apply this, thanks!
