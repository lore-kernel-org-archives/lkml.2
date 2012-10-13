Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2JMODF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:03:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2JMODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:03:02 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nhG9hhDKd-0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=L9t51SWWDt0A:10 a=20KFwNOVAAAA:8 a=Xs81qnP24Utfw_N3sU0A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350136980.24256.98.camel@gandalf.local.home>
Subject: Re: [PATCH 23/25] unicore32: Use Kbuild infrastructure for 
 kvm_para.h
From: Steven Rostedt <rostedt@goodmis.org>
To: guanxuetao@mprc.pku.edu.cn
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 13 Oct 2012 10:03:00 -0400
In-Reply-To: <4190.124.205.227.162.1350131263.squirrel@mprc.pku.edu.cn>
References: <20121013022632.024527228@goodmis.org>
	 <20121013022955.738395112@goodmis.org>
	 <4190.124.205.227.162.1350131263.squirrel@mprc.pku.edu.cn>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-13 at 20:27 +0800, guanxuetao@mprc.pku.edu.cn wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > All the headers but kvm_para.h use the Kbuild infrastructure to
> > get to the asm-generic headers.
> 
> I merged the uapi patch for unicore32.
> In that patch, kvm_para.h was moved to
> arch/unicore32/include/uapi/asm/kvm_para.h.
> Anyway, I'd like to apply this patch based on uapi modification.
> 

Sure, do whatever you want ;-)

-- Steve


