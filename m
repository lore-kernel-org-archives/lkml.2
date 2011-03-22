Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1CVNLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:11:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39799 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1CVNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pwAzG3Z/V98+IoMSWLqdxSoCxQP+eNiHauejnTzMzXYCGWpL0KgYxO6YPGkyDzGJ5y
         aeRTVaGIG8CQJKzFndmOT7UcXUnOT8rMQAI+NvYKuTUVR1NMG5GHufji3qycsQpgnodq
         aOym6MoX7RbaarJnBpVlg40elzoPRr2ouKSaQ=
Date: Tue, 22 Mar 2011 14:11:31 +0100
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [RFC PATCHSET] ptrace,signal: Fix notifications to the real
 parent while ptraced
Message-ID: <20110322131131.GS12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

The updated patches should address the issues pointed out in your
reviews, at least the ones which are appropriate to address now.
Please let me know when you want the whole series resent.

Thanks.

-- 
tejun
