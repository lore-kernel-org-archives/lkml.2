Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0HBCTB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:19:01 -0400
Received: from tundra.namei.org ([65.99.196.166]:54212 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab0HBCS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:18:59 -0400
Date: Mon, 2 Aug 2010 12:18:46 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: linux-kernel@vger.kernel.org
cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
        Kees Cook <kees.cook@canonical.com>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
In-Reply-To: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
Message-ID: <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org>
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010, James Morris wrote:

> One issue which needs to be addressed is to confirm that there is 
> consensus on the new Yama LSM module.  I had thought there was, based on 
> list discussion, but have since had differing feedback.

I'm going to revert the Yama stuff for 2.6.36 -- Christoph has nacked it 
to me off-list.


- James
-- 
James Morris
<jmorris@namei.org>
