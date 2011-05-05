Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1EEHyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:54:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59443 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1EEHyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ryDLLXqzdpdQxG1Qd0+naZsjEjJeB/Um3HnH9xzZUXNQuODxO360AZ/+8DZx7Ri2CI
         dLV8Iutlqeuq6n3iSx2fCOT9TcL3fCE2pEl4A3AgXVToRZfJUonSGbUAG1znsrhLZBsf
         t1YVpLmjTlQj0OIFxY7z/osVbGZ/U8FNkOvq0=
Date: Thu, 5 May 2011 09:53:58 +0200
From: Tejun Heo <htejun@gmail.com>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        jaxboe@fusionio.com, hch@infradead.org, jgarzik@pobox.com,
        djwong@us.ibm.com, sshtylyov@mvista.com
Subject: Re: [patch v3 1/3] block: add a non-queueable flush flag
Message-ID: <20110505075358.GA30950@htj.dyndns.org>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.586891398@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505020417.586891398@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 09:59:33AM +0800, shaohua.li@intel.com wrote:
> flush request isn't queueable in some drives. Add a flag to let driver
> notify block layer about this. We can optimize flush performance with the
> knowledge.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
