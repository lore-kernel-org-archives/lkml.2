Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2BIMSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:18:37 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:51220 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab2BIMSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:18:34 -0500
In-Reply-To: <4F3390FB.80107@redhat.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com> <4F3390FB.80107@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: BORNTRAE@linux.vnet.ibm.com, James Bottomley <JBottomley@parallels.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au
MIME-Version: 1.0
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
X-KeepSent: DF7B0B80:B44589BA-C125799F:00410C52;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFDF7B0B80.B44589BA-ONC125799F.00410C52-C125799F.00439AD0@de.ibm.com>
From: Christian Hoff <christian.hoff@de.ibm.com>
Date: Thu, 9 Feb 2012 13:18:21 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 09/02/2012 13:18:25,
	Serialize by Notes Client on Christian Hoff/Germany/IBM(Release 8.5.2FP3|Aug
 10, 2010) at 09/02/2012 13:18:25,
	Serialize complete at 09/02/2012 13:18:25,
	S/MIME Sign failed at 09/02/2012 13:18:25: The cryptographic key was not
 found,
	Serialize by Router on D06MC042/06/M/IBM(Release 8.5.2FP3|July 10, 2011) at
 09/02/2012 13:18:23,
	Serialize complete at 09/02/2012 13:18:23
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 12020912-4966-0000-0000-000001687E54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote:
> James, will you include virtio-scsi in 3.4?

The key arguments from my side for inclusion of virtio-scsi are:
- Support for SCSI multipathing, which can optionally be done on the host 
operating system.
- We can now use other SCSI(non-block) devices and make them accessible to 
the guest. For example we were able to virtualize a SCSI FCP tape using 
virtio-scsi. One of the biggest constraints of virtio-block is that it is 
limited to block devices, while virtio-scsi presents you with a more 
generic solution.

So I consider virtio-scsi to be the cleaner approach to do virtualization 
of SCSI commands. This is supported by the fact that virtio-block has a 
maintenance problem and has to change its protocol from time to time to 
support new features introduced by a new version of the SCSI standard.

So please consider including virtio-scsi into the mainline kernel tree. 
This is good and conceptually clean code, and it has proven to work very 
well in our internal testing.

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

