Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1HZUzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:55:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1HZUzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:55:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=OPoFQs+3gz8z09FEyx6EvgKp6X6o7FBoxAgGOpa35Bz3P/jm74lpFr0wgAF5w2bTz
	ic3awjr4gr1jBYMT+Rv3w==
MIME-Version: 1.0
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com> <1314390834-3411-1-git-send-email-gregkh@suse.de>
From: Mike Waychison <mikew@google.com>
Date: Fri, 26 Aug 2011 13:54:42 -0700
Message-ID: <CAGTjWtC1aGp2Qmnu0Lv25zKK8JYPX=NcitZoTCp=bQB3crhVEQ@mail.gmail.com>
Subject: Re: [PATCH 01/13] firmware: fix google/gsmi.c build warning
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 1:33 PM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Modify function parameter type to match expected type.  Fixes a
> build warning:
>
> drivers/firmware/google/gsmi.c:473: warning: initialization from incompatible pointer type
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Acked.
