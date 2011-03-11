Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1CKKwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 05:52:15 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58875 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1CKKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 05:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TK7ivWdrB+2I7sNJ89U5KuoH+ea+oFFsXzC8LqRPNFs6ciVpTJe54d0rX3gyfwp8up
         PxDEqoeqCLfrcs7Y2l4tbysPHrupunjVdmlYvOWEMuRtzOY3O5hcil+WVwJqLKH7IOrw
         fDQlEJXMowDUbW55ELYn8yyh/7yNMDJxH5hho=
Subject: Re: [PATCH/RFC v4 1/3] Shared BCH ECC library
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ivan Djelic <ivan.djelic@parrot.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1fb708d8d49cdd83e62424fb77912418f5c92d69.1299836869.git.ivan.djelic@parrot.com>
References: <1fb708d8d49cdd83e62424fb77912418f5c92d69.1299836869.git.ivan.djelic@parrot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 12:50:42 +0200
Message-ID: <1299840642.2732.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 11:05 +0100, Ivan Djelic wrote:
> Hello,
> 
> The first patch of this series contains a new generic BCH ECC library.
> 
> This library can be used to provide software BCH correction on NAND devices
> (see 2nd and 3rd patch), as well as error correction for hybrid hardware BCH
> engines.
> 
> This version v4 fixes coding style issues.
> 
> Could you please review and comment ?
> Thanks,

I've updated my tree with these patches, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

