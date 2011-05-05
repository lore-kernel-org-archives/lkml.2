Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1EEHyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:54:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59443 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1EEHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DvyCWV1mobv1GzfkUxMl8xzYfYOLFtJHRk+TXXYfUPRNc4ZaS5azJMnbMBC6y8EDI0
         GaTsnq7T3EvU4VVHuLFTDGMaZaPkUyDDPGgjinMnUtIxwh5/bri+fbBON/cGfhccCg5e
         ZGThRHdmZOvIyDweIJYi+JT3wfyNV8GZS0keI=
Date: Thu, 5 May 2011 09:54:18 +0200
From: Tejun Heo <htejun@gmail.com>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        jaxboe@fusionio.com, hch@infradead.org, jgarzik@pobox.com,
        djwong@us.ibm.com, sshtylyov@mvista.com
Subject: Re: [patch v3 3/3] SATA: enable non-queueable flush flag
Message-ID: <20110505075418.GB30950@htj.dyndns.org>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.986492128@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505020417.986492128@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 09:59:35AM +0800, shaohua.li@intel.com wrote:
> Enable non-queueable flush flag for SATA.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
