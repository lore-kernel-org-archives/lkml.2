Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2BHNhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:37:34 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:46261 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab2BHNhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:37:31 -0500
In-Reply-To: <4F313526.2050907@redhat.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: BORNTRAE@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mst@redhat.com, rusty@rustcorp.com.au
MIME-Version: 1.0
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
X-KeepSent: 36197712:1A42EB9E-C125799E:0049E3C2;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
From: Christian Hoff <christian.hoff@de.ibm.com>
Date: Wed, 8 Feb 2012 14:37:16 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 08/02/2012 14:37:21,
	Serialize by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 08/02/2012 14:37:21,
	Serialize complete at 08/02/2012 14:37:21,
	S/MIME Sign failed at 08/02/2012 14:37:21: The cryptographic key was not
 found,
	Serialize by Router on D06MC042/06/M/IBM(Release 8.5.2FP3|July 10, 2011) at
 08/02/2012 14:37:20,
	Serialize complete at 08/02/2012 14:37:20
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 12020813-5024-0000-0000-000001A391BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote:
> Christian Hoff wrote:
> > Instead the format has some disadvantages:
> > - It uses up 8 bytes where 3 bytes would be sufficient in order to 
store
> > both the target ID and LUN number information
> > - The format limits us to 255 target IDs. I agree that the LUN limit 
is
> > probably more a theoretical and not a practical one, but 255 target 
IDs
> > could become a limitation in the future.
>
> It also provides better upwards-compatibility in case the limitations 
> are actually hit.  If I had used "uint8_t target; uint16_t lun;" an 
> extension would require a feature bit and a new struct.  With 8-bytes, 
> you can just expand the definition.  That pretty much sums it up.

Ok, fair enough. This addresses my question.

Again, I have already done much testing with virtio-scsi and can confirm 
that the code is working flawlessly. In my opinion, virtio-scsi is a 
worthwhile addition to virtio-block and should be considered for inclusion 
into mainline kernel code.

Mit freundlichen Grüßen / Kind regards

Christian Hoff

Student - Applied Computer Science


Phone:
49-16098976-950
 IBM Deutschland

E-Mail:
christian.hoff@de.ibm.com
 Am Fichtenberg 1


 71083 Herrenberg


 Germany


IBM Deutschland GmbH / Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Martina Koederitz (Vorsitzende), Reinhard Reschke, 
Dieter Scholz, Gregor Pillen, Joachim Heel, Christian Noll
Sitz der Gesellschaft: Ehningen / Registergericht: Amtsgericht Stuttgart, 
HRB 14562 / WEEE-Reg.-Nr. DE 99369940 

