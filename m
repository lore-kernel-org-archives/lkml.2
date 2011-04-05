Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab1DEPjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:39:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35626 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab1DEPjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:in-reply-to:references:content-type
         :x-mailer:content-transfer-encoding:message-id:mime-version;
        b=o4kyExsQVrooMGscgBNe1iXKwy6LvJNDQsyLoB7SjWMAT358/SKmOoHkRY3evQFe8t
         u4mVhWbSISeE3Za8WwVuqDzKl5ZhOI+Xj8HKKOG6fHkfqt7lP43wh4Wxpu2Q/k9kv+cx
         P3B5nOXsboRrrvFko/NMRhb91zL/T1HMkm77E=
Subject: Re: [PATCH v2]arch:x86:kvm:i8254.h Remove base_addresss in kvm_pit
 since it is unused.
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: trivial@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Apr 2011 08:38:47 -0700
In-Reply-To: <4D9AD14D.3020705@redhat.com>
References: <1301504087-3266-1-git-send-email-justinmattock@gmail.com>
	 <4D9AD14D.3020705@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.92 (2.91.92-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1302017931.1888.8.camel@Linux-2>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-05 at 11:22 +0300, Avi Kivity wrote:
> On 03/30/2011 06:54 PM, Justin P. Mattock wrote:
> > The patch below removes unsigned long base_addresss; in i8254.h
> > since it is unused.
> >
> 
> Applied, thanks.
> 

o.k. avi... your welcome, and thank you for being patient with me..
(I'm not the best at code, but am willing to learn and work at it to get
better).

Justin P. Mattock

