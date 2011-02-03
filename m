Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1BCCoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:44:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37337 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab1BCCoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:44:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=OBLpyUjdU7QZyLkaVuAdNN8mTrXWnd+zULDQJy7rZOQvDl8fT68+f08FPzmvFC2qbc
         Uw8ec1FRpdVlXWaCnPQPXGTal5UQW4INOIRGd0vM38wvFbU+T8MpXEegBKyShleJXfN/
         MIheZoJ35PuUPsYX4LrUz8d94jo91ULlGzQyw=
Date: Thu, 3 Feb 2011 10:44:11 +0800
From: Harry Wei <harryxiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: Re: Fwd: A problem about linux/Documentation/SubmittingPatches
Message-ID: <20110203024410.GA2564@gmail.com>
References: <20110202174531.GA7717@gmail.com>
 <20110202124633.e2380a77.rdunlap@xenotime.net>
 <20110202205352.GA29053@kroah.com>
 <AANLkTikPM3m4D=qdzA0SHQG4J+ukH5jYSHC8zEMj_oH=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikPM3m4D=qdzA0SHQG4J+ukH5jYSHC8zEMj_oH=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 10:27:47AM +0800, harryxiyou wrote:
> ---------- Forwarded message ----------
> From: Greg KH <greg@kroah.com>
> Date: Wed, 2 Feb 2011 12:53:52 -0800
> Subject: Re: A problem about linux/Documentation/SubmittingPatches
> To: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Harry Wei <harryxiyou@gmail.com>, linux-kernel@vger.kernel.org,
> akpm@linux-foundation.org
> 
> On Wed, Feb 02, 2011 at 12:46:33PM -0800, Randy Dunlap wrote:
> > On Thu, 3 Feb 2011 01:45:32 +0800 Harry Wei wrote:
> >
> > > Hi us,
> > >    I have seen linux-2.6.7/Documentation/SubmittingPatches but it hasn't described how to submit a translated document to kernel. I have also sent mail to <linux-kernel@zh-kernel.org>, however, there is no response.
> > >    I have translated linux-2.6.37/Decumentation/SecurityBugs(no one translated it up to now). I'd like to send it to maintainers, then add it into kernel directories. However, I don't know how i can do it. Can anyone tell me howto do it? Thanks so much :)
> >
> > Hi,
> >
> > AFAIK, Greg KH handles all of the translation merging.
> >
> > Right, Greg?
> 
> Yes, please feel free to send me any translations in patch form and I
     Patch form? There is no patch form for translation document in kernel directories. Following is my translation document(for linux-2.6.37/Documentation/SecurityBugs). I have translated it(linux-2.6.37/Documentation/SecurityBugs) into Chinese.

     /*
	Translator: Harry Wei <harryxiyou@gmail.com>.
	*/

     Linux�ں˿�������Ϊ��ȫ�ǳ���Ҫ�����ˣ�������Ҫ֪����һ���й���

     ��ȫ��©�������ֵ�ʱ�򣬲��������ܻᱻ�������޸����߹���������������ȫ

     ©��������Linux�ں˰�ȫ�Ŷӡ�

     1) ��ϵ

     linux�ں˰�ȫ�Ŷӿ���ͨ��email<security@kernel.org>����ϵ������

     һ�������İ�ȫ������Ա����?԰�������©�����沢�ҹ�����ȡ��һ���޸�����

     ȫ�Ŷ��п��ܻ��Ӳ��ֵ�ά�����������������İ������˽Ⲣ���޸���ȫ©����
     �������κ�©���������ṩ����ϢԽ����Խ�����Ϻ��޸��������㲻��

     ��ʲô���а�������Ϣ���Ǿ�������һ��REPORTING-BUGS�ļ��еĸ������̡���

     �ι����ԵĴ��붼�Ƿǳ����õģ�δ�������ߵ�ͬ�ⲻ�ᱻȡ�����������Ѿ���

     �������ڡ�

     2) ����

     Linux�ں˰�ȫ�Ŷӵ���ּ���Ǻ�©���ύ��һ������©���Ľ�������ֱ

     ������������ϲ����������ȫ����©������һ��©������?޸���û�б���ȫ����

     �⣬��������û��ͨ�����Ի��߹�Ӧ��Э�������Ժ������ӳٹ�����Ȼ��������

     ������Щ�ӳپ����ܵĶ�Щ���ǿ����ļ��죬�����Ǽ������ڻ��߼����¡�����

     ������ͨ����ȫ�ŶӺ�©���ṩ���Լ���Ӧ��Ǣ̸���Ľ���������ʱ�����ǴӺ�

     �̣������ģ����Ѿ���������֪�������������ڡ���Ϊһ��������Ĭ�����ߣ���

     ��������֪ͨ���ڵ�������7���İ��š�

     3) ����Э��

     Linux�ں˰�ȫ�ŶӲ���һ����ʽ�����壬���˲��ܼ����κεı���Э�顣

     Best Regards.
     Harry Wei.
> will be glad to merge them.
> 
> thanks,
> 
> greg k-h
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!
