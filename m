Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0LHVNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:13:44 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab0LHVNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:13:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TPODW80/c/+VZhXsiohpxfeI1ZBX/Hv7BVyF/t6jgt0jDFaFlL+Azw7k5fH5w2k5CO
         oqmlG8k2yIAwUEy/K0HQ==
Date: Wed, 8 Dec 2010 13:13:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jovi Zhang <bookjovi@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix single_open usage
In-Reply-To: <1291695703-2093-1-git-send-email-bookjovi@gmail.com>
Message-ID: <alpine.DEB.2.00.1012081312540.15658@chino.kir.corp.google.com>
References: <1291695703-2093-1-git-send-email-bookjovi@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, bookjovi@gmail.com wrote:

> fix some single_open function usage, use private_data as parameter
> 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
