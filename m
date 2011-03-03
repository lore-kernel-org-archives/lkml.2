Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1CCGVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:21:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63766 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1CCGVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:21:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SnKN5SKonC23UCVJ9kZ34AHz8Z7PLWwIgNx80HRia7BGvPgrzVeUQB4VG5gj03qL67
         vOR+XLOZsG0nU6cnUkcxWw/qg+3k579XMpBNfoJIV36nOCCOED6IKKA1fN1Os43ItFAW
         Ut9q502czMDFqaDhFKNqioDTIOCrf/oxMldM8=
Date: Thu, 3 Mar 2011 07:21:30 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, numa, emu: move size calculation into if block
Message-ID: <20110303062130.GH28266@mtj.dyndns.org>
References: <4D6EEDF2.6090201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EEDF2.6090201@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Yinghai.

On Wed, Mar 02, 2011 at 05:25:06PM -0800, Yinghai Lu wrote:
> don't need to assign them that early.

You know I'm not gonna take this, right?  Don't make it uglier.

Thanks.

-- 
tejun
