Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1CCGcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:32:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab1CCGcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P4SXfYndwt/GLHL6ZmcHLEVDnJvEDhGuXgV1nyoQQH6f1y8kEbzfh6RQb72k7VoGuw
         6mVVQdpRhW0+PBsZ82VLLodrGf+rCFRSxhIlU9l0kVFCbEpDaN2c9JbtQCfV7nJZSHtf
         RQkjtSnZdyfA0bg7kIOPwDzjSDGEPeod7Rd6A=
Date: Thu, 3 Mar 2011 07:32:25 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, numa: move bootnode definition into srat_64.c
Message-ID: <20110303063225.GK28266@mtj.dyndns.org>
References: <4D6EECE8.80500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EECE8.80500@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:20:40PM -0800, Yinghai Lu wrote:
> only one user there for hot memory add.

Again, please use proper sentences.

 Only srat_64 hot memory add code uses struct bootnode.  Move its
 definition into srat_64.c

Thanks.

-- 
tejun
