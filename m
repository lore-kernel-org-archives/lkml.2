Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1DEIXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:23:14 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54288 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1DEIXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:23:11 -0400
Subject: Re: Native KVM: can't boot existing Fedora 14 image
From: Paul Bolle <pebolle@tiscali.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Apr 2011 10:23:04 +0200
In-Reply-To: <4D9A7DF6.1040101@gmail.com>
References: <4D9A7DF6.1040101@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.92 (2.91.92-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1301991791.1923.12.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 20:27 -0600, David Ahern wrote:
> At that point it loops over a few iterations of the last few lines and I
> kill it. Any ideas why?

What happens if you remove the (hardcoded) "root=vda" kernel parameter
from the commandline (in tools/kvm/main.c)?


PUal Bolle

