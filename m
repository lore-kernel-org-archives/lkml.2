Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab0CaQmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 12:42:06 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64240 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab0CaQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 12:42:01 -0400
Date: Wed, 31 Mar 2010 09:40:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Giridhar Malavali <giridhar.malavali@qlogic.com>, james.bottomley@suse.de
Cc: Ferenc Wagner <wferi@niif.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       LinuxSCSI <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] qla2xxx: Fix documentation of ql2xfdmienable module
 parameter
Message-Id: <20100331094023.933bc3e5.randy.dunlap@oracle.com>
In-Reply-To: <C7CED2FA.5FEB%giridhar.malavali@qlogic.com>
References: <87634n0xkc.fsf@tac.ki.iif.hu>
	<C7CED2FA.5FEB%giridhar.malavali@qlogic.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB37B36.00E0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 20:20:10 -0700 Giridhar Malavali wrote:

> 
> 
> 
> On 3/23/10 10:14 AM, "Ferenc Wagner" <wferi@niif.hu> wrote:
> 
> > The default is enabled since 7e47e5ca184548341a82eeb2238ee3622c43cae1.
> > 
> > Signed-off-by: Ferenc Wagner <wferi@niif.hu>

Hi James,

What is the best way for any interested party to tell if you have merged (applied,
accepted) a patch in the scsi subsystem?

Thanks.

> > ---
> >  drivers/scsi/qla2xxx/qla_os.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> > index 46720b2..ac08397 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -69,8 +69,8 @@ static void qla2x00_free_device(scsi_qla_host_t *);
> >  int ql2xfdmienable=1;
> >  module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
> >  MODULE_PARM_DESC(ql2xfdmienable,
> > -               "Enables FDMI registratons "
> > -               "Default is 0 - no FDMI. 1 - perfom FDMI.");
> > +               "Enables FDMI registrations. "
> > +               "0 - no FDMI. Default is 1 - perform FDMI.");
> > 
> >  #define MAX_Q_DEPTH    32
> >  static int ql2xmaxqdepth = MAX_Q_DEPTH;
> > --
> 
> Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>


---
~Randy
