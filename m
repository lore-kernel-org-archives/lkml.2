Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2CKQB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 12:01:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41682 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752695Ab2CKQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 12:01:28 -0400
Date: Sun, 11 Mar 2012 12:01:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: "K. Y. Srinivasan" <kys@microsoft.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devel@linuxdriverproject.org>,
        <virtualization@lists.osdl.org>, <ohering@suse.com>
Subject: Re: [PATCH 2/4] Drivers: hv: Support the newly introduced KVP messages
 in the driver
In-Reply-To: <20120311104230.GC3337@mwanda>
Message-ID: <Pine.LNX.4.44L0.1203111157590.5402-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012, Dan Carpenter wrote:

> Btw I don't know if utf16s_to_utf8s() counts the NUL char or not.
> It feels like maybe we could end up with ->value_size equal to
> HV_KVP_EXCHANGE_MAX_VALUE_SIZE + 1.

It does not count NUL characters.  If it encounters a NUL character in
the input, it stops right away without copying that character to the
output.  If it reaches the end of the input, it does not add a
terminating NUL character to the output.

Alan Stern

