Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab0GVAGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:06:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37835 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759144Ab0GVAG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:06:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GtxBOTyj7QEUA6kd51ydvMwCaqZS48V8uVJXy/wxrP3k8ItfUr2+tZCu+7oUDVqn2s
         rNqm0X2WeNZBiUmz+N/7tnw3ZAHRXHwSV28R5kqQGWe/0rCJ7q1CqQAMXo3yu7Z6pUw6
         hf7AJ3L7k1eW5pgw8Za66ase9IDG6dn+0qjPs=
Date: Thu, 22 Jul 2010 02:06:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/18] lkdtm: use generic_file_llseek in debugfs
Message-ID: <20100722000623.GE5801@nowhere>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278538820-1392-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:40:05PM +0200, Arnd Bergmann wrote:
> When the default llseek behavior gets changed to
> not allowing seek, all file operations that rely
> on the current behaviour need to use an explicit
> .llseek operation.
> 
> The files that lkdtm uses in debugfs are regular
> files and they get read using simple_read_from_buffer,
> so generic_file_llseek is the right operation.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---



Applied, thanks.

