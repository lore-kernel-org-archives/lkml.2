Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1FTMrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:47:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36925 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1FTMrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=x2OF5xQvmcNbvRyFVPubJ0qzsbo0HpzW8xZqkyaCq4DyxFjSkPY4HUUCCg8NDCP7HC
         QebLoGoVUuC1tv/C7u707oqUfWCnWD9DfUc9WrzYJtwyNemAMDrHcnnH2Q7zSbk7TCsi
         OTASIzAJbAA4eyXXLxbdFpHdRNsf3BF9H43ME=
Date: Mon, 20 Jun 2011 14:47:38 +0200
From: Tejun Heo <tj@kernel.org>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        sshtylyov@mvista.com, Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH v4] ahci: move ahci_sb600_softreset to libahci.c and
 rename it
Message-ID: <20110620124738.GO2611@htj.dyndns.org>
References: <20110617120704.GH2611@htj.dyndns.org>
 <1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
 <20110620081937.GN2611@htj.dyndns.org>
 <BANLkTi=dgTNUESCstJNFUg6_YLbfwpNF5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=dgTNUESCstJNFUg6_YLbfwpNF5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jun 20, 2011 at 06:06:52PM +0800, Yuan-Hsin Chen wrote:
> > Heh, I know I suggested that name but that is one ugly name.  If
> > anyone has any better idea, please come forward.
> 
> How about ahci_pmp_workaround_softreset or ahci_pmp_ipms_set_softreset?
> Also applys to ops, ahci_pmp_workaround_ops or ahci_pmp_ipms_set_ops.

Heh, maybe.  ahci_pmp_workaround_softreset is a bit generic but at
least doesn't completely stupid.  I don't know. :)

Thanks.

-- 
tejun
