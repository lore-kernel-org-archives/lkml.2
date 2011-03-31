Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab1CaSUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:20:55 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58469 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758903Ab1CaSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:20:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ns8sHeh0aYzOj8ZolrWHS7+3YklK6Mt0Pfxw06ty78x+g7DsAiUElGStCSByYBjv6a0oXuqkSe6OU3Q84UVKQ+FYog3AT3nQHlOzU8TjAkhTcHlU5HVJo4dy1zZymIXO;
Date: Thu, 31 Mar 2011 11:20:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a typo 'an hardware => a hardware'
Message-Id: <20110331112051.082fe0c3.rdunlap@xenotime.net>
In-Reply-To: <1301595039.27408.14.camel@losinj.inria.fr>
References: <1301595039.27408.14.camel@losinj.inria.fr>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.42.51 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 20:10:39 +0200 Sylvestre Ledru wrote:

> Hello,
> 
> Here is a patch which fixes an other minor typo issue.

Hi Sylvestre,

I merged your earlier patch because it mostly modified Documentation/,
which I maintain.  Since these 2 patches are not like that, please send
them to the trivial patch maintainer.

---
~Randy
