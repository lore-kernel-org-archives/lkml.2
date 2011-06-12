Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1FLCxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 22:53:40 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:33607 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1FLCxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 22:53:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=tr+PeYZidWGXI8fIC9R1WWQ2mqVd6LSaTodMH7ahoIKHPEbqK2RCapDcSG/SgmUV2E
         sjPOk6Ks4bu38uMlkTPbHQKeDfqRZc0aYawhU7QYl4oPfN99oh9k/elg9tYYI/eFKFoL
         X+fbw2I4Dk+lB80zGWe5BYp4sQZQmMlyc2W/A=
Date: Sun, 12 Jun 2011 10:53:21 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4]Documentation/zh_CN: Remove messy code
 documentations and rebuild new documentations
Message-ID: <20110612025319.GA2035@gmail.com>
Mail-Followup-To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20110611023749.GA2101@gmail.com>
 <20110611200513.GA14582@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <20110611200513.GA14582@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 01:05:13PM -0700, Greg KH wrote:
> On Sat, Jun 11, 2011 at 10:37:52AM +0800, Harry Wei wrote:
> > From: Harry Wei <harryxiyou@gmail.com>
> > 
> > There are two messy code documentations in our
> > Documentation/zh_CN/ directory. They are
> > Documentation/zh_CN/email-clients.txt &
> > Documentation/zh_CN/SubmitChecklist.
> > The following patches can fix them.
> > 
> > Harry Wei (4)
> > Documentation/zh_CN: remove messy code file email-clients.txt
> > Documentation/zh_CN: remove messy code file SubmitChecklist
> > Documentation/zh_CN: add new file email-clients.txt
> > Documentation/zh_CN: add new file SubmitChecklist
> 
> Why are you deleting and then adding back the files?  
> Why not just edit them and change them in one single patch?
Hmmm..., what about two patches? One for editing and changing 
email-clients.txt and the other one for editing and changing 
SubmitChecklist.
> What made them "messy" in the first place?
Maybe it is something wrong with my mutt client. It can not
deal with Chinese characters. So i can only send them with 
attachments now. So sorry for this. I have also fix my 
mutt client, but it seems to be useless. I will try to fix
it later.

Thanks
Harry Wei
