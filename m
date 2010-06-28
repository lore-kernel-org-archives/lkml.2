Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0F1Moh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:44:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0F1Mog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:44:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277621246-10960-3-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-3-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, sds@tycho.nsa.gov,
       lenb@kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 2/5]security:ebitmap.c Fix warning: variable 'e_sft' set but not used
Date: Mon, 28 Jun 2010 13:44:03 +0100
Message-ID: <7140.1277729043@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

> gcc is giving me this during compiling:
>   CC      security/selinux/ss/ebitmap.o
> security/selinux/ss/ebitmap.c: In function 'ebitmap_netlbl_import':
> security/selinux/ss/ebitmap.c:159:27: warning: variable 'e_sft' set but not used
> 
> The below fixes this warning for me.
> (please check this whenever you have time).
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>

(though I wonder if e_sft should be used for something...)
